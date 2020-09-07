enum PageStatus{
  loading,
  success,
  error,
  empty,
}

///根据结果判断状态
PageStatus getResultStatus( result) {
  PageStatus status = PageStatus.success;
  if (result == null) {
    status = PageStatus.error;
  } else {
    if (result.length == 0) {
      status = PageStatus.empty;
    }
  }
  return status;
}