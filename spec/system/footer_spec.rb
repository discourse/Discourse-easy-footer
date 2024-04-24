# frozen_string_literal: true

RSpec.describe "Footer", system: true do
  let!(:theme) { upload_theme_component }

  it "should display the footer" do
    theme.update_setting(
      :sections,
      [
        {
          text: "Section 1",
          title: "Section 1 title",
          links: [
            {
              text: "Section 1 Link",
              url: "http://some.url.com/section1/link1",
              title: "Section 1 Link Title",
              referrer_policy: "origin",
            },
            {
              text: "Section 1 Link 2",
              url: "http://some.url.com/section1/link2",
              target: "_self",
              title: "Section 1 Link 2 Title",
            },
          ],
        },
        {
          text: "Section 2",
          title: "Section 2 title",
          links: [
            {
              text: "Section 2 Link",
              url: "http://some.url.com/section2/link1",
              title: "Section 2 Link Title",
            },
            {
              text: "Section 2 Link 2",
              url: "http://some.url.com/section2/link2",
              title: "Section 2 Link 2 Title",
            },
          ],
        },
      ],
    )

    theme.save!

    visit("/")

    expect(page).to have_css(".below-footer-outlet.custom-footer")
    expect(page).to have_css(".below-footer-outlet .heading", text: theme.get_setting(:heading))
    expect(page).to have_css(".below-footer-outlet .blurb", text: theme.get_setting(:blurb))

    within(".below-footer-outlet .links .list[data-easyfooter-section='section-1']") do
      expect(page).to have_css("span[title='Section 1 title']", text: "Section 1")

      expect(page).to have_selector(
        "a[href='http://some.url.com/section1/link1'][title='Section 1 Link Title'][referrerpolicy='origin']",
      )

      expect(page).to have_link(
        "Section 1 Link 2",
        href: "http://some.url.com/section1/link2",
        target: "_self",
        title: "Section 1 Link 2 Title",
      )
    end

    within(".below-footer-outlet .links .list[data-easyfooter-section='section-2']") do
      expect(page).to have_css("span[title='Section 2 title']", text: "Section 2")

      expect(page).to have_link(
        "Section 2 Link",
        href: "http://some.url.com/section2/link1",
        title: "Section 2 Link Title",
      )

      expect(page).to have_link(
        "Section 2 Link 2",
        href: "http://some.url.com/section2/link2",
        title: "Section 2 Link 2 Title",
      )
    end

    within(".below-footer-outlet .footer-links") do
      expect(page).to have_link("Privacy", href: "#")
      expect(page).to have_link("Terms of service", href: "#")
      expect(page).to have_link("About", href: "#")
    end

    within(".below-footer-outlet .social") do
      expect(page).to have_css(
        "a.social-link[data-easyfooter-social-link='facebook'][title='Join us on Facebook'][href='#'][target='_blank'] .d-icon-fab-facebook",
      )

      expect(page).to have_css(
        "a.social-link[data-easyfooter-social-link='twitter'][title='show some love on Twitter'][href='#'][target='_blank'] .d-icon-fab-twitter",
      )

      expect(page).to have_css(
        "a.social-link[data-easyfooter-social-link='youtube'][title='Check out our latest videos on Youtube'][href='#'][target='_blank'] .d-icon-fab-youtube",
      )
    end
  end

  it "should display the footer to anon users when `show_footer_on_login_required_page` is true" do
    SiteSetting.login_required = true

    theme.update_setting(:show_footer_on_login_required_page, true)
    theme.save!

    visit("/")

    expect(page).to have_css(".below-footer-outlet.custom-footer")
  end

  it "should not display the footer to anon users when `show_footer_on_login_required_page` is false" do
    SiteSetting.login_required = true

    theme.update_setting(:show_footer_on_login_required_page, false)
    theme.save!

    visit("/")

    expect(page).not_to have_css(".below-footer-outlet.custom-footer")
  end
end
