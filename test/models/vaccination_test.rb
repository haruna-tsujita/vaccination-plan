# frozen_string_literal: true

require 'test_helper'

class VaccinationTest < ActiveSupport::TestCase
  test 'when regular vaccination' do
    vaccination = 'pneumococcus_2'
    regular_vaccination = vaccinations(:"#{vaccination}") # rubocopに指摘されるので
    assert regular_vaccination.regular?
  end

  test 'when not regular vaccination' do
    vaccination = 'mumps_2'
    not_regular_vaccination = vaccinations(:"#{vaccination}") # rubocopに指摘されるので
    assert_not not_regular_vaccination.regular?
  end
end
