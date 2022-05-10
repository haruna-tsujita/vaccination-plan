# frozen_string_literal: true

class Vaccination < ApplicationRecord
  VACCINATION_NAME = ['ヒブ', 'Ｂ型肝炎', 'ロタウイルス', '小児用肺炎球菌', '４種混合', '２種混合', 'ＢＣＧ', '麻しん・風しん混合', '水痘', 'おたふくかぜ', '日本脳炎'].freeze

  has_one :history, dependent: :nullify

  def self.regular?(vaccination_name)
    key = Vaccination.find_by(name: vaccination_name).key
    JpVaccination.find(key).regular
  end
end
