# frozen_string_literal: true

require 'test_helper'

class VaccinationTest < ActiveSupport::TestCase
  test 'when regular vaccination' do
    vaccination = 'pneumococcus_2'
    regular_vaccination = vaccinations(:"#{vaccination}").name # rubocopに指摘されるので
    assert Vaccination.regular?(regular_vaccination)
  end

  test 'when not regular vaccination' do
    vaccination = 'mumps_2'
    not_regular_vaccination = vaccinations(:"#{vaccination}").name # rubocopに指摘されるので
    assert_not Vaccination.regular?(not_regular_vaccination)
  end

  test 'output formal_name' do
    history = histories(:dave_history_chickenpox_second)
    assert_equal '水痘 2回目', Vaccination.vaccination_formal_name(history)
  end
end
