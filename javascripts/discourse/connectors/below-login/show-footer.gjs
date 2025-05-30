import Component from "@ember/component";
import { tagName } from "@ember-decorators/component";
import hideApplicationFooter from "discourse/helpers/hide-application-footer";

@tagName("")
export default class ShowFooter extends Component {
  <template>
    {{#unless settings.show_footer_on_login_required_page}}
      {{hideApplicationFooter}}
    {{/unless}}
  </template>
}
