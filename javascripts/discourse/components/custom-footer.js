import Component from "@glimmer/component";
import { dasherize } from "@ember/string";

export default class extends Component {
  mainHeading = settings.heading;
  blurb = settings.blurb;

  socialLinks = settings.social_links
    .split("|")
    .filter(Boolean)
    .map((link) => {
      const fragments = link.split(",").map((fragment) => fragment.trim());
      const text = fragments[0];
      const dataName = dasherize(text);
      const title = fragments[1];
      const href = fragments[2];
      const target = fragments[3] === "blank" ? "_blank" : "";
      const icon = fragments[4].toLowerCase();

      return {
        text,
        dataName,
        title,
        href,
        target,
        icon,
      };
    });
}
