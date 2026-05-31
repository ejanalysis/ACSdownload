test_that("get_acs_old is a defunct shim that points users at get_acs_new", {
  expect_error(get_acs_old(), "removed in ACSdownload 3.0.0")
  expect_error(get_acs_old(), "get_acs_new")
  # It must ignore any arguments rather than complaining about them.
  expect_error(get_acs_old(tables = "B01001", state = "AL"),
               "removed in ACSdownload 3.0.0")
})
