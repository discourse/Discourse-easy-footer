import Component from "@glimmer/component";
import { dasherize } from "@ember/string";
import PluginOutlet from "discourse/components/plugin-outlet";
import concatClass from "discourse/helpers/concat-class";
import icon from "discourse/helpers/d-icon";
import I18nInstance from "discourse-i18n";

export default class extends Component {
  get mainHeading() {
    return (
      this.translationFor(settings.heading_translations)?.text ||
      settings.heading
    );
  }

  get blurb() {
    return (
      this.translationFor(settings.blurb_translations)?.text || settings.blurb
    );
  }

  get sections() {
    return (settings.sections || []).map((section) => ({
      ...section,
      slug: dasherize(section.text),
      text: this.localized(section, "text"),
      title: this.localized(section, "title"),
      links: (section.links || []).map((link) => this.localizedLink(link)),
    }));
  }

  get smallLinks() {
    return (settings.small_links || []).map((link) => this.localizedLink(link));
  }

  get socialLinks() {
    return (settings.social_links || []).map((link) =>
      this.localizedLink(link)
    );
  }

  localizedLink(link) {
    return {
      ...link,
      slug: dasherize(link.text),
      text: this.localized(link, "text"),
      title: this.localized(link, "title"),
    };
  }

  translationFor(translations) {
    const locale = I18nInstance.currentLocale();
    return (translations || []).find((t) => t.locale === locale);
  }

  localized(obj, field) {
    return this.translationFor(obj.translations)?.[field] || obj[field];
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
                {{#each this.sections as |section|}}
                  <div class="list" data-easyfooter-section={{section.slug}}>
                    <span title={{section.title}}>
                      {{section.text}}
                    </span>

                    <ul>
                      {{#each section.links as |link|}}
                        <li
                          class="footer-section-link-wrapper"
                          data-easyfooter-link={{link.slug}}
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
              {{#each this.smallLinks as |link|}}
                <a
                  class={{concatClass "small-link" link.css_class}}
                  data-easyfooter-small-link={{link.slug}}
                  target={{link.target}}
                  href={{link.url}}
                >
                  {{link.text}}
                </a>
              {{/each}}
            </div>

            <div class="social">
              {{#each this.socialLinks as |link|}}
                <a
                  class="social-link"
                  data-easyfooter-social-link={{link.slug}}
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
