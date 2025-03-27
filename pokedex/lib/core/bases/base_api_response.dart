class BaseAPIResponse<F, S> {
  F? _failureResponse;
  S? _successResponse;

  setFailureResponse(F failureRes) {
    _failureResponse = failureRes;
  }

  setSuccessResponse(S successRes) {
    _successResponse = successRes;
  }

  F? get failureResponse => _failureResponse;

  S? get successResponse => _successResponse;
}