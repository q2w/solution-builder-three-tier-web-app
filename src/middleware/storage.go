// Copyright 2021 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package main

import "fmt"

// Storage is a wrapper for combined cache and database operations
type Storage struct {
	sqlstorage SQLStorage
	cache      *Cache // Cache is now optional (can be nil)
}

// Init kicks off the database connector and optionally the cache connector
func (s *Storage) Init(user, password, host, name, conn, redisHost, redisPort string, cache bool) error {
	// Initialize the SQL storage
	if err := s.sqlstorage.Init(user, password, host, name, conn); err != nil {
		return err
	}

	// Initialize the cache only if redisHost is not empty
	if redisHost != "" {
		var err error
		s.cache, err = NewCache(redisHost, redisPort, cache)
		if err != nil {
			return err
		}
	}

	return nil
}

func (s Storage) List() (Todos, error) {
	// If cache is not initialized, fall back to SQL storage
	if s.cache == nil {
		return s.sqlstorage.List()
	}

	// Use cache if available, else fallback to SQL storage
	ts, err := s.cache.List()
	if err != nil {
		if err == ErrCacheMiss {
			ts, err = s.sqlstorage.List()
			if err != nil {
				return ts, fmt.Errorf("error getting todo: %v", err)
			}
		}
		if err := s.cache.SaveList(ts); err != nil {
			return ts, fmt.Errorf("error caching todo : %v", err)
		}
	}

	return ts, nil
}

// Create records a new todo in the database.
func (s Storage) Create(t Todo) (Todo, error) {
	// If cache is initialized, clear it
	if s.cache != nil {
		if err := s.cache.DeleteList(); err != nil {
			return Todo{}, fmt.Errorf("error clearing cache : %v", err)
		}
	}

	// Create the todo in the database
	t, err := s.sqlstorage.Create(t)
	if err != nil {
		return t, err
	}

	// If cache is initialized, save to cache
	if s.cache != nil {
		if err = s.cache.Save(t); err != nil {
			return t, err
		}
	}

	return t, nil
}

// Read returns a single todo from cache or database
func (s Storage) Read(id string) (Todo, error) {
	// If cache is not initialized, fallback to SQL storage directly
	if s.cache == nil {
		return s.sqlstorage.Read(id)
	}

	// First, attempt to get the todo from cache
	t, err := s.cache.Get(id)
	if err != nil {
		if err == ErrCacheMiss {
			// If the item is not in cache, fetch it from SQL storage
			t, err = s.sqlstorage.Read(id)
			if err != nil {
				return t, fmt.Errorf("error getting todo: %v", err)
			}
		}
		// Save the fetched todo to the cache if it was fetched from DB
		if err := s.cache.Save(t); err != nil {
			return t, fmt.Errorf("error caching todo : %v", err)
		}
	}

	return t, nil
}

// Update changes one todo in the database.
func (s Storage) Update(t Todo) error {
	// If cache is initialized, clear it
	if s.cache != nil {
		if err := s.cache.DeleteList(); err != nil {
			return fmt.Errorf("error clearing cache : %v", err)
		}
	}

	// Update the todo in the database
	if err := s.sqlstorage.Update(t); err != nil {
		return err
	}

	// If cache is initialized, save the updated todo to cache
	if s.cache != nil {
		if err := s.cache.Save(t); err != nil {
			return err
		}
	}

	return nil
}

// Delete removes one todo from the database.
func (s Storage) Delete(id string) error {
	// If cache is initialized, clear the cache list
	if s.cache != nil {
		if err := s.cache.DeleteList(); err != nil {
			return fmt.Errorf("error clearing cache : %v", err)
		}
	}

	// Delete the todo from the database
	if err := s.sqlstorage.Delete(id); err != nil {
		return err
	}

	// If cache is initialized, remove the todo from cache
	if s.cache != nil {
		if err := s.cache.Delete(id); err != nil {
			return err
		}
	}

	return nil
}
