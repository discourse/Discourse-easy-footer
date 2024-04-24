import { module, test } from "qunit";
import migrate from "../../../../migrations/settings/0002-migrate-settings";

module("Unit | Migrations | Settings | 0002-migrate-settings", function () {
  test("migrate links with valid target attribute", async function (assert) {
    const settings = new Map(
      Object.entries({
        link_sections: "Section Name, Section Title",
        links:
          "Section Name, Link 1, #, blank, Link 1 Title|Section Name, Link 2, #, self, Link 2 Title",
      })
    );

    const result = migrate(settings);

    const expectedResult = new Map(
      Object.entries({
        sections: [
          {
            text: "Section Name",
            title: "Section Title",
            links: [
              {
                text: "Link 1",
                url: "#",
                target: "_blank",
                title: "Link 1 Title",
              },
              {
                text: "Link 2",
                url: "#",
                target: "_self",
                title: "Link 2 Title",
              },
            ],
          },
        ],
      })
    );

    assert.deepEqual(
      Object.fromEntries(result.entries()),
      Object.fromEntries(expectedResult.entries())
    );
  });

  test("migrate links with invalid target attribute", async function (assert) {
    const settings = new Map(
      Object.entries({
        link_sections: "Section Name, Section Title",
        links: "Section Name, Link 1, #, invalid_target, Link Title",
      })
    );

    const result = migrate(settings);

    const expectedResult = new Map(
      Object.entries({
        sections: [
          {
            text: "Section Name",
            title: "Section Title",
            links: [
              {
                text: "Link 1",
                url: "#",
                title: "Link Title",
              },
            ],
          },
        ],
      })
    );

    assert.deepEqual(
      Object.fromEntries(result.entries()),
      Object.fromEntries(expectedResult.entries())
    );
  });

  test("migrate links with valid referrerpolicy attribute", async function (assert) {
    const settings = new Map(
      Object.entries({
        link_sections: "Section Name, Section Title",
        links: "Section Name, Link 1, #, blank, Link Title, no-referrer",
      })
    );

    const result = migrate(settings);

    const expectedResult = new Map(
      Object.entries({
        sections: [
          {
            text: "Section Name",
            title: "Section Title",
            links: [
              {
                text: "Link 1",
                url: "#",
                target: "_blank",
                title: "Link Title",
                referrer_policy: "no-referrer",
              },
            ],
          },
        ],
      })
    );

    assert.deepEqual(
      Object.fromEntries(result.entries()),
      Object.fromEntries(expectedResult.entries())
    );
  });

  test("migrate links with invalid referrerpolicy attribute", async function (assert) {
    const settings = new Map(
      Object.entries({
        link_sections: "Section Name, Section Title",
        links:
          "Section Name, Link 1, #, blank, Link Title, invalid_referrerpolicy",
      })
    );

    const result = migrate(settings);

    const expectedResult = new Map(
      Object.entries({
        sections: [
          {
            text: "Section Name",
            title: "Section Title",
            links: [
              {
                text: "Link 1",
                url: "#",
                target: "_blank",
                title: "Link Title",
              },
            ],
          },
        ],
      })
    );

    assert.deepEqual(
      Object.fromEntries(result.entries()),
      Object.fromEntries(expectedResult.entries())
    );
  });

  test("migrate links which incorrectly set title as target", async function (assert) {
    const settings = new Map(
      Object.entries({
        link_sections: "Design, Get inspired!",
        links: "Design, Design process, #, Learn the basics",
      })
    );

    const result = migrate(settings);

    const expectedResult = new Map(
      Object.entries({
        sections: [
          {
            text: "Design",
            title: "Get inspired!",
            links: [
              {
                text: "Design process",
                url: "#",
                title: "Learn the basics",
              },
            ],
          },
        ],
      })
    );

    assert.deepEqual(
      Object.fromEntries(result.entries()),
      Object.fromEntries(expectedResult.entries())
    );
  });

  test("migrate", function (assert) {
    const settings = new Map(
      Object.entries({
        link_sections: "Design, Get inspired!|Code, Learn new things!",
        links:
          "Design, Design process, #, blank, Learn the basics|Design, Blog design, #, self, What makes for a great blog?|Design, Photoshop tutorials, #, invalid_target, Photoshop for beginners|Design, Design trends, #, blank, Stay on top of the current trends!|Code, Wordpress, #, blank, Wordpress code examples|Code, Tools, #, blank, Tools that will make your life easier!|Code, Tutorials, #, blank, Just starting out? We'll guide you through the basics",
      })
    );

    const result = migrate(settings);

    const expectedResult = new Map(
      Object.entries({
        sections: [
          {
            text: "Design",
            title: "Get inspired!",
            links: [
              {
                text: "Design process",
                url: "#",
                target: "_blank",
                title: "Learn the basics",
              },
              {
                text: "Blog design",
                url: "#",
                target: "_self",
                title: "What makes for a great blog?",
              },
              {
                text: "Photoshop tutorials",
                url: "#",
                title: "Photoshop for beginners",
              },
              {
                text: "Design trends",
                url: "#",
                target: "_blank",
                title: "Stay on top of the current trends!",
              },
            ],
          },
          {
            text: "Code",
            title: "Learn new things!",
            links: [
              {
                text: "Wordpress",
                url: "#",
                target: "_blank",
                title: "Wordpress code examples",
              },
              {
                text: "Tools",
                url: "#",
                target: "_blank",
                title: "Tools that will make your life easier!",
              },
              {
                text: "Tutorials",
                url: "#",
                target: "_blank",
                title: "Just starting out? We'll guide you through the basics",
              },
            ],
          },
        ],
      })
    );

    assert.deepEqual(
      Object.fromEntries(result.entries()),
      Object.fromEntries(expectedResult.entries())
    );
  });
});
