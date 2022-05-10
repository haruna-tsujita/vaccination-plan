# frozen_string_literal: true

require 'test_helper'

class HistoryTest < ActiveSupport::TestCase
  test 'automatically_vaccinated' do
    carol = children(:carol)
    vaccination = vaccinations(:pneumococcus_3)
    history = History.new(child: carol, vaccination: vaccination, date: Date.current)
    history.save
    History.automatically_vaccinated(vaccination.id, carol.id)
    assert_equal true, History.find_by(child: carol, vaccination: Vaccination.find_by(key: vaccinations(:pneumococcus_1).key)).vaccinated
    assert_equal true, History.find_by(child: carol, vaccination: Vaccination.find_by(key: vaccinations(:pneumococcus_2).key)).vaccinated
    assert_nil History.find_by(child: carol, vaccination: Vaccination.find_by(key: vaccinations(:pneumococcus_4).key))
  end
end
