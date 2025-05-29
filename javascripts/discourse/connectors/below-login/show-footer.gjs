import Component from "@ember/component";
import { tagName } from "@ember-decorators/component";
import { not } from "truth-helpers";
import hideApplicationFooter from "discourse/helpers/hide-application-footer";
import themeSetting from "discourse/helpers/theme-setting";

@tagName("")
export default class ShowFooter extends Component {
  <template>
    {{#if (not (themeSetting "show_footer_on_login_required_page"))}}
      {{hideApplicationFooter}}
    {{/if}}
  </template>
}
