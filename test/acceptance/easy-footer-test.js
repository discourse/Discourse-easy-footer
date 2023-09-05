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

    assert.ok(exists(".below-footer-outlet"));
    assert.equal(
      queryAll(".below-footer-outlet .first-box .heading").text().trim(),
      "This is a header"
    );
    assert.ok(exists(".below-footer-outlet .second-box .links"));
    assert.ok(exists(".below-footer-outlet .third-box .footer-links"));
    assert.ok(exists(".below-footer-outlet .third-box .social"));
  });
});
