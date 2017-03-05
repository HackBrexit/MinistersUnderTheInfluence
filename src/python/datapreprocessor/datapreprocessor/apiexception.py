class ApiException(Exception):
    pass

class BadRequest(ApiException):
    pass

class InternalSeverError(ApiException):
    pass
