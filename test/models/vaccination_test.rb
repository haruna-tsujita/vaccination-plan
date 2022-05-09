# frozen_string_literal: true

require 'test_helper'

class VaccinationTest < ActiveSupport::TestCase
  test 'when regular vaccination' do
    regular_vaccination = vaccinations(:pneumococcus_2).name
    assert Vaccination.regular?(regular_vaccination)
  end

  test 'when not regular vaccination' do
    not_regular_vaccination = vaccinations(:mumps_2).name
    assert_not Vaccination.regular?(not_regular_vaccination)
  end

  test 'output formal_name' do
    history = histories(:dave_history_chickenpox_second)
    assert_equal '水痘 2回目', Vaccination.vaccination_formal_name(history)
  end
end
