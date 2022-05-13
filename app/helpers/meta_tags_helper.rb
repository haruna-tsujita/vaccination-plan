# frozen_string_literal: true

module MetaTagsHelper
  def default_meta_tags  # rubocop:disable Metrics/MethodLength
    {
      site: 'ワクチンプラン',
      title: 'ワクチンプラン',
      reverse: true,
      charset: 'utf-8',
      description: 'お子さんの予防接種の予定を自動計算します。',
      viewport: 'width=device-width, initial-scale=1.0',
      og: {
        title: :title,
        type: 'website',
        site_name: 'ワクチンプラン',
        description: :description,
        image: image_url('ogp.jpg'),
        url: 'https://vaccination-plan.herokuapp.com/'
      },
      twitter: {
        title: :title,
        card: 'summary_large_image',
        site: '@napple29',
        description: :description,
        image: image_url('ogp.png'),
        domain: 'https://vaccination-plan.herokuapp.com/'
      }
    }
  end
end
