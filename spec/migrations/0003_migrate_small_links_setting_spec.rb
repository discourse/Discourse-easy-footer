# frozen_string_literal: true

RSpec.describe "0003-migrate-small-links-setting migration" do
  let!(:theme) { upload_theme_component }

  it "should set target property to `_blank` if previous target component is not valid or empty" do
    theme.theme_settings.create!(
      name: "small_links",
      theme: theme,
      data_type: ThemeSetting.types[:string],
      value: "some text, #|some text 2, #, invalid target",
    )

    run_theme_migration(theme, "0003-migrate-small-links-setting")

    expect(theme.settings[:small_links].value).to eq(
      [
        { "text" => "some text", "url" => "#", "target" => "_blank" },
        { "text" => "some text 2", "url" => "#", "target" => "_blank" },
      ],
    )
  end

  it "should set URL property to `#` if previous URL component is not valid, empty or more than 2048 chars" do
    theme.theme_settings.create!(
      name: "small_links",
      theme: theme,
      data_type: ThemeSetting.types[:string],
      value: "some text, not a valid URL|some text 2,,,|some text 3, #|some text 4, #{"a" * 2049}",
    )

    run_theme_migration(theme, "0003-migrate-small-links-setting")

    expect(theme.settings[:small_links].value).to eq(
      [
        { "text" => "some text", "url" => "#", "target" => "_blank" },
        { "text" => "some text 2", "url" => "#", "target" => "_blank" },
        { "text" => "some text 3", "url" => "#", "target" => "_blank" },
        { "text" => "some text 4", "url" => "#", "target" => "_blank" },
      ],
    )
  end

  it "should truncate text property to 1000 chars if previous text property is more than 1000 chars" do
    theme.theme_settings.create!(
      name: "small_links",
      theme: theme,
      data_type: ThemeSetting.types[:string],
      value: "#{"a" * 1001}, /some/url",
    )

    run_theme_migration(theme, "0003-migrate-small-links-setting")

    expect(theme.settings[:small_links].value).to eq(
      [{ "text" => "#{"a" * 1000}", "url" => "/some/url", "target" => "_blank" }],
    )
  end

  it "should not migrate small links setting if text component does not exist" do
    theme.theme_settings.create!(
      name: "small_links",
      theme: theme,
      data_type: ThemeSetting.types[:string],
      value: ",/some/url|,,,|some text,/some/url",
    )

    run_theme_migration(theme, "0003-migrate-small-links-setting")

    expect(theme.settings[:small_links].value).to eq(
      [{ "text" => "some text", "url" => "/some/url", "target" => "_blank" }],
    )
  end

  it "should migrate the small links setting to objects type correctly" do
    theme.theme_settings.create!(
      name: "small_links",
      theme: theme,
      data_type: ThemeSetting.types[:string],
      value: "some text,/some/url,blank|some text 2,/some/url2,self|",
    )

    run_theme_migration(theme, "0003-migrate-small-links-setting")

    expect(theme.settings[:small_links].value).to eq(
      [
        { "text" => "some text", "url" => "/some/url", "target" => "_blank" },
        { "text" => "some text 2", "url" => "/some/url2", "target" => "_self" },
      ],
    )
  end
end
