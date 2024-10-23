# frozen_string_literal: true

# rubocop:disable RSpec/DescribeClass
RSpec.describe "0004-migrate-social-links-setting migration" do
  let!(:theme) { upload_theme_component }

  it "should handle an empty string for old setting" do
    theme.theme_settings.create!(
      name: "social_links",
      theme:,
      data_type: ThemeSetting.types[:string],
      value: "    ",
    )

    run_theme_migration(theme, "0004-migrate-social-links-setting")

    expect(theme.settings[:social_links].value).to eq([])
  end

  it "does not migrate links which do not have a text property" do
    theme.theme_settings.create!(
      name: "social_links",
      theme:,
      data_type: ThemeSetting.types[:string],
      value: "   ,some title, /some/url",
    )

    run_theme_migration(theme, "0004-migrate-social-links-setting")

    expect(theme.settings[:social_links].value).to eq([])
  end

  it "should migrate title property correctly if previous title property is valid" do
    theme.theme_settings.create!(
      name: "social_links",
      theme:,
      data_type: ThemeSetting.types[:string],
      value: "Some Text, Some Title",
    )

    run_theme_migration(theme, "0004-migrate-social-links-setting")

    expect(theme.settings[:social_links].value).to eq(
      [{ "text" => "Some Text", "title" => "Some Title", "url" => "#", "target" => "_blank" }],
    )
  end

  it "should truncate title property to 1000 chars if previous title property is more than 1000 chars" do
    theme.theme_settings.create!(
      name: "social_links",
      theme:,
      data_type: ThemeSetting.types[:string],
      value: "Some Text, #{"a" * 1001}",
    )

    run_theme_migration(theme, "0004-migrate-social-links-setting")

    expect(theme.settings[:social_links].value).to eq(
      [{ "text" => "Some Text", "title" => "#{"a" * 1000}", "url" => "#", "target" => "_blank" }],
    )
  end

  it "should set URL property to `#` if previous URL property is invalid, empty or is more than 2048 chars" do
    theme.theme_settings.create!(
      name: "social_links",
      theme:,
      data_type: ThemeSetting.types[:string],
      value:
        "Some Text, Some Title|Some Text 2, Some Title 2, not a URL|Some Text 3, Some Title 3, #{"a" * 2049}",
    )

    run_theme_migration(theme, "0004-migrate-social-links-setting")

    expect(theme.settings[:social_links].value).to eq(
      [
        { "text" => "Some Text", "title" => "Some Title", "url" => "#", "target" => "_blank" },
        { "text" => "Some Text 2", "title" => "Some Title 2", "url" => "#", "target" => "_blank" },
        { "text" => "Some Text 3", "title" => "Some Title 3", "url" => "#", "target" => "_blank" },
      ],
    )
  end

  it "should migrate URL property correctly if previous URL property is valid" do
    theme.theme_settings.create!(
      name: "social_links",
      theme:,
      data_type: ThemeSetting.types[:string],
      value: "Some Text, Some Title, /some/url|Some Text 2, Some Title 2, http://example.com",
    )

    run_theme_migration(theme, "0004-migrate-social-links-setting")

    expect(theme.settings[:social_links].value).to eq(
      [
        {
          "text" => "Some Text",
          "title" => "Some Title",
          "url" => "/some/url",
          "target" => "_blank",
        },
        {
          "text" => "Some Text 2",
          "title" => "Some Title 2",
          "url" => "http://example.com",
          "target" => "_blank",
        },
      ],
    )
  end

  it "sets target property to `_self` if previous target property is `self`" do
    theme.theme_settings.create!(
      name: "social_links",
      theme:,
      data_type: ThemeSetting.types[:string],
      value: "Some Text, Some Title, /some/url, self",
    )

    run_theme_migration(theme, "0004-migrate-social-links-setting")

    expect(theme.settings[:social_links].value).to eq(
      [
        {
          "text" => "Some Text",
          "title" => "Some Title",
          "url" => "/some/url",
          "target" => "_self",
        },
      ],
    )
  end

  it "does not set target property if previous target property is invalid or empty" do
    theme.theme_settings.create!(
      name: "social_links",
      theme:,
      data_type: ThemeSetting.types[:string],
      value:
        "Some Text, Some Title, /some/url|Some Text 2, Some Title 2, http://example.com, not a target",
    )

    run_theme_migration(theme, "0004-migrate-social-links-setting")

    expect(theme.settings[:social_links].value).to eq(
      [
        {
          "text" => "Some Text",
          "title" => "Some Title",
          "url" => "/some/url",
          "target" => "_blank",
        },
        {
          "text" => "Some Text 2",
          "title" => "Some Title 2",
          "url" => "http://example.com",
          "target" => "_blank",
        },
      ],
    )
  end

  it "does not set icon_name property if previous icon_name property is empty or more than 200 chars" do
    theme.theme_settings.create!(
      name: "social_links",
      theme:,
      data_type: ThemeSetting.types[:string],
      value:
        "Some Text, Some Title, /some/url, self|Some Text 2, Some Title 2, http://example.com, self, #{"a" * 201}",
    )

    run_theme_migration(theme, "0004-migrate-social-links-setting")

    expect(theme.settings[:social_links].value).to eq(
      [
        {
          "text" => "Some Text",
          "title" => "Some Title",
          "url" => "/some/url",
          "target" => "_self",
        },
        {
          "text" => "Some Text 2",
          "title" => "Some Title 2",
          "url" => "http://example.com",
          "target" => "_self",
        },
      ],
    )
  end

  it "sets the icon_name property correctly if previous icon_name property is present" do
    theme.theme_settings.create!(
      name: "social_links",
      theme:,
      data_type: ThemeSetting.types[:string],
      value: "Some Text, Some Title, /some/url, self, some-icon",
    )

    run_theme_migration(theme, "0004-migrate-social-links-setting")

    expect(theme.settings[:social_links].value).to eq(
      [
        {
          "text" => "Some Text",
          "title" => "Some Title",
          "url" => "/some/url",
          "target" => "_self",
          "icon_name" => "some-icon",
        },
      ],
    )
  end
end
