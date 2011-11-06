class FakeExceptionController < Spree::BaseController

  # This is for deliberately creating a runtime exception in order to test error reporting/emailing.

  def exception

    raise RuntimeError, "Generating a spurious exception"

  end
end
