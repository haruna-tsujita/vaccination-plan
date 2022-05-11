# frozen_string_literal: true

require 'test_helper'

class HistoryTest < ActiveSupport::TestCase
  test 'automatically_vaccinated' do
    carol = children(:carol)
    vaccination_key = 'pneumococcus_3'
    vaccination = vaccinations(:"#{vaccination_key}")
    history = History.new(child: carol, vaccination: vaccination, date: Date.current)
    history.save
    History.automatically_vaccinated(vaccination.id, carol.id)
    pneumococcus_first = 'pneumococcus_1'
    pneumococcus_second = 'pneumococcus_2'
    pneumococcus_fourth = 'pneumococcus_4'
    assert_equal true, History.find_by(child: carol, vaccination: Vaccination.find_by(key: vaccinations(:"#{pneumococcus_first}").key)).vaccinated
    assert_equal true, History.find_by(child: carol, vaccination: Vaccination.find_by(key: vaccinations(:"#{pneumococcus_second}").key)).vaccinated
    assert_nil History.find_by(child: carol, vaccination: Vaccination.find_by(key: vaccinations(:"#{pneumococcus_fourth}").key))
  end
end
