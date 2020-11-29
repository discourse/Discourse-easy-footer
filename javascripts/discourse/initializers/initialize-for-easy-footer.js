import { withPluginApi } from "discourse/lib/plugin-api";
import { on } from "discourse-common/utils/decorators";

export default {
  name: "show-footer-on-static-pages",
  initialize() {
    withPluginApi("0.8", api => {
      if (settings.Show_footer_on_login_required_page) {
        api.modifyClass("controller:static", {
          @on("init")
          showFooterOnStatic() {
            this.set("application.showFooter", true);
          }
        });
      }
    });
  }
};
