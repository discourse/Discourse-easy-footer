import Component from "@ember/component";
import { classNames, tagName } from "@ember-decorators/component";
import CustomFooter0 from "../../components/custom-footer";

@tagName("div")
@classNames("below-footer-outlet", "custom-footer")
export default class CustomFooter extends Component {
  <template><CustomFooter0 @showFooter={{@outletArgs.showFooter}} /></template>
}
