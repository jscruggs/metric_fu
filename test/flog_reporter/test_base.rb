class TestFlogReporterBase < Test::Unit::TestCase
  def setup
    @alpha_only_method = <<-AOM
    Total score = 13.6283678106927

    ErrorMailer#errormail: (12.5)
        12.0: assignment
         1.2: []
         1.2: now
         1.2: content_type
AOM

    @method_that_has_digits = <<-MTHD
    Total score = 7.08378429936994

    NoImmunizationReason#to_c32: (7.1)
         3.0: code
         2.3: branch
         1.4: templateId
         1.2: act
         1.1: entryRelationship
MTHD

    @bang_method = <<-BM
    Total score = 7.08378429936994

    NoImmunizationReason#to_c32!: (7.1)
         3.0: code
         2.3: branch
         1.4: templateId
         1.2: act
         1.1: entryRelationship
BM
  end
  
  def test_parse_alpha_only_method
    page = MetricFu::FlogReporter::Base.parse(@alpha_only_method)
    assert page
    assert_equal 13.6283678106927, page.score
    assert_equal 1, page.scanned_methods.size
    sm = page.scanned_methods.first
    assert_equal 'ErrorMailer#errormail', sm.name
    assert_equal 12.5, sm.score
  end
  
  def test_parse_method_that_has_digits
    page = MetricFu::FlogReporter::Base.parse(@method_that_has_digits)
    assert page
    assert_equal 7.08378429936994, page.score
    assert_equal 1, page.scanned_methods.size
    sm = page.scanned_methods.first
    assert_equal 'NoImmunizationReason#to_c32', sm.name
    assert_equal 7.1, sm.score
  end
  
  def test_parse_bang_method
    page = MetricFu::FlogReporter::Base.parse(@bang_method)
    assert page
    assert_equal 7.08378429936994, page.score
    assert_equal 1, page.scanned_methods.size
    sm = page.scanned_methods.first
    assert_equal 'NoImmunizationReason#to_c32!', sm.name
    assert_equal 7.1, sm.score
  end
end