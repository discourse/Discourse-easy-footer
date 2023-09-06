import { visit } from "@ember/test-helpers";
import {
  acceptance,
  exists,
  queryAll,
} from "discourse/tests/helpers/qunit-helpers";
import { test } from "qunit";

acceptance("easy-footer", function (needs) {
  needs.user();

  test("shows the footer", async function (assert) {
    await visit("/categories");

    assert.dom(".below-footer-outlet").exists();
    assert.dom(".below-footer-outlet .first-box .heading").hasText("This is a header");
    assert.dom(".below-footer-outlet .second-box .links").exists();
    assert.dom(".below-footer-outlet .third-box .footer-links").exists();
    assert.dom(".below-footer-outlet .third-box .social").exists();
  });
});
