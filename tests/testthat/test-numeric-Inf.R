library(pROC)

invalid.controls <- c(-Inf, 1,2,3,4,5)
invalid.cases <- c(2,3,4,5,6)

valid.controls <- c(1,2,3,4,5)
valid.cases <- c(2,3,4,5,6, Inf)

test_that("Algorithm 2 and DeLong rejects infinities", {
	expect_error(roc(controls = invalid.controls, cases = invalid.cases, algorithm=2))
})

test_that("DeLong rejects infinities", {
	r1 <- roc(controls = valid.controls, cases = valid.cases, algorithm=1)
	expect_error(pROC:::delongPlacements(r1))
	expect_warning(out <- ci.auc(r1, method="delong", boot.n = 2))
	expect_identical(attr(out, "method"), "bootstrap")
	expect_warning(out <- var(r1, method="delong", boot.n = 2))
	expect_warning(out <- cov(r1, r1, method="delong", boot.n = 2))
	expect_warning(out <- roc.test(r1, r1, method="delong", boot.n = 2))
	expect_true(grepl("Bootstrap", out$method))
})
