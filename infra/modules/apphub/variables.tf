variable "project_id"{
    type = string
}

variable "host_project_id" {
    type = string
}

variable "location"{
    type = string
}

variable "application_id"{
    type = string
}

variable "display_name" {
    type = string
}

variable "description" {
    type = string
    default = ""
}

variable "scope_type"{
    type = string
}

variable "environment_type"{
    type = string
}

variable "criticality_type"{
    type = string
}

variable "owner_name"{
    type = string
}

variable "owner_email"{
    type = string
}

variable "service_uris"{
    type = list(object({service_uri: string, service_id: string}))
    default = []
}

variable "workload_uris"{
    type = list(object({workload_uri: string, workload_id: string}))
    default = []
}