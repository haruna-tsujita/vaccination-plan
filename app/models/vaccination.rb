# frozen_string_literal: true

class Vaccination < ApplicationRecord
  VACCINATION_NAME = ['ヒブ', 'Ｂ型肝炎', 'ロタウイルス', '小児用肺炎球菌', '４種混合', '２種混合', 'ＢＣＧ', '麻しん・風しん混合', '水痘', 'おたふくかぜ', '日本脳炎'].freeze

  has_one :history, dependent: :nullify

  def self.vaccination_formal_name(history)
    vaccination = Vaccination.find(history.vaccination_id)
    "#{vaccination.name} #{vaccination.period}"
  end
end
