import { visit } from "@ember/test-helpers";
import { acceptance } from "discourse/tests/helpers/qunit-helpers";
import { test } from "qunit";

acceptance("Easy Footer - enabled", function (needs) {
  needs.user();

  test("shows the footer", async function (assert) {
    await visit("/categories");

    assert.dom(".below-footer-outlet").exists();
    assert
      .dom(".below-footer-outlet .first-box .heading")
      .hasText("This is a header");
    assert.dom(".below-footer-outlet .second-box .links").exists();
    assert.dom(".below-footer-outlet .third-box .footer-links").exists();
    assert.dom(".below-footer-outlet .third-box .social").exists();
  });
});

acceptance("Easy Footer - login required", function (needs) {
  needs.settings({ login_required: true });

  test("hides the footer on the login required page", async function (assert) {
    settings.Show_footer_on_login_required_page = false;
    await visit("/");

    assert.dom(".below-footer-outlet.custom-footer .wrap").doesNotExist();
  });
});
