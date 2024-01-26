import { module, test } from "qunit";
import migrate from "../../../../migrations/settings/0001-rename-settings";

module("Unit | Migrations | Settings | 0001-rename-settings", function () {
  test("migrate", function (assert) {
    const settings = new Map(
      Object.entries({
        Heading: "some header",
        Blurb: "some blurb",
        Link_sections: "section1|section2",
        Links: "some_links",
        Small_links: "some,small,links",
        Social_links: "some,social,links",
        Show_footer_on_login_required_page: true,
      })
    );

    const result = migrate(settings);

    assert.deepEqual(
      Array.from(result),
      Array.from(
        new Map(
          Object.entries({
            heading: "some header",
            blurb: "some blurb",
            link_sections: "section1|section2",
            links: "some_links",
            small_links: "some,small,links",
            social_links: "some,social,links",
            show_footer_on_login_required_page: true,
          })
        )
      )
    );
  });
});
