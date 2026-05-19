import Component from "@glimmer/component";
import PluginOutlet from "discourse/components/plugin-outlet";
import concatClass from "discourse/helpers/concat-class";
import icon from "discourse/helpers/d-icon";
import dasherize from "discourse/helpers/dasherize";


export default class extends Component {
  get activeSettings() {
    const currentLocale = I18n.currentLocale();
    const localizedContent = settings.localized_footer_content;

    if (localizedContent && localizedContent.length > 0) {
      const exactMatch = localizedContent.find((c) => c.locale === currentLocale);
      if (exactMatch) {
        return exactMatch;
      }

      const langPart = currentLocale.split("_")[0];
      if (langPart) {
        const langMatch = localizedContent.find((c) => c.locale === langPart);
        if (langMatch) {
          return langMatch;
        }
      }
    }

    return settings;
  }

  <template>
    {{#if @showFooter}}
      <div class="wrap">
        <div class="flexbox">
          <div class="first-box">
            <div class="heading">
              {{this.activeSettings.heading}}
            </div>
            <div class="blurb">
              {{this.activeSettings.blurb}}
            </div>
          </div>
          <div class="second-box">
            <PluginOutlet @name="easy-footer-second-box">
              <div class="links">
                {{#each this.activeSettings.sections as |section|}}
                  <div
                    class="list"
                    data-easyfooter-section={{dasherize section.text}}
                  >
                    <span title={{section.title}}>
                      {{section.text}}
                    </span>

                    <ul>
                      {{#each section.links as |link|}}
                        <li
                          class="footer-section-link-wrapper"
                          data-easyfooter-link={{dasherize link.text}}
                        >
                          <a
                            class="footer-section-link"
                            title={{link.title}}
                            href={{link.url}}
                            target={{link.target}}
                            referrerpolicy={{link.referrer_policy}}
                          >
                            {{link.text}}
                          </a>
                        </li>
                      {{/each}}
                    </ul>
                  </div>
                {{/each}}
              </div>
            </PluginOutlet>
          </div>

          <div class="third-box">
            <div class="footer-links">
              {{#each this.activeSettings.small_links as |link|}}
                <a
                  class={{concatClass "small-link" link.css_class}}
                  data-easyfooter-small-link={{dasherize link.text}}
                  target={{link.target}}
                  href={{link.url}}
                >
                  {{link.text}}
                </a>
              {{/each}}
            </div>

            <div class="social">
              {{#each this.activeSettings.social_links as |link|}}
                <a
                  class="social-link"
                  data-easyfooter-social-link={{dasherize link.text}}
                  title={{link.title}}
                  target={{link.target}}
                  href={{link.url}}
                >
                  {{icon link.icon_name}}
                </a>
              {{/each}}
            </div>
          </div>
        </div>
      </div>
    {{/if}}
  </template>
}
