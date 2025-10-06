import Component from "@glimmer/component";
import PluginOutlet from "discourse/components/plugin-outlet";
import icon from "discourse/helpers/d-icon";
import dasherize from "discourse/helpers/dasherize";

export default class extends Component {
  mainHeading = settings.heading;
  blurb = settings.blurb;

  getLinkClasses(link) {
    return `small-link${link.css_class ? ` ${link.css_class}` : ""}`;
  }

  <template>
    {{#if @showFooter}}
      <div class="wrap">
        <div class="flexbox">
          <div class="first-box">
            <div class="heading">
              {{this.mainHeading}}
            </div>
            <div class="blurb">
              {{this.blurb}}
            </div>
          </div>
          <div class="second-box">
            <PluginOutlet @name="easy-footer-second-box">
              <div class="links">
                {{#each settings.sections as |section|}}
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
              {{#each settings.small_links as |link|}}
                <a
                  class={{this.getLinkClasses link}}
                  data-easyfooter-small-link={{dasherize link.text}}
                  target={{link.target}}
                  href={{link.url}}
                >
                  {{link.text}}
                </a>
              {{/each}}
            </div>

            <div class="social">
              {{#each settings.social_links as |link|}}
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
