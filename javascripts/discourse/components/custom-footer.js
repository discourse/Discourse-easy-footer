import Component from "@glimmer/component";
import { dasherize } from "@ember/string";

export default class extends Component {
  mainHeading = settings.Heading;
  blurb = settings.Blurb;

  linkArray = settings.Links.split("|")
    .filter(Boolean)
    .map((link) => {
      const fragments = link.split(",").map((fragment) => fragment.trim());
      const parent = fragments[0].toLowerCase();
      const text = fragments[1];
      const dataName = dasherize(text);
      const href = fragments[2];
      const target = fragments[3] === "blank" ? "_blank" : "";
      const title = "title=`"+fragments[4]+"'";
      const attributes = fragments[5];

      return {
        parent,
        text,
        dataName,
        href,
        target,
        title,
        attributes,
      };
    });

  linkSections = settings.Link_sections.split("|")
    .filter(Boolean)
    .map((section) => {
      const fragments = section.split(",").map((fragment) => fragment.trim());
      const parentFor = fragments[0].toLowerCase();
      const text = fragments[0];
      const title = fragments[1];
      const dataName = dasherize(text);
      const childLinks = this.linkArray.filter(
        (link) => link.parent === parentFor
      );

      return {
        text,
        title,
        dataName,
        childLinks,
      };
    });

  smallLinks = settings.Small_links.split("|")
    .filter(Boolean)
    .map((link) => {
      const fragments = link.split(",").map((fragment) => fragment.trim());
      const text = fragments[0];
      const dataName = dasherize(text);
      const href = fragments[1];
      const target = fragments[2] === "blank" ? "_blank" : "";

      return {
        text,
        dataName,
        href,
        target,
      };
    });

  socialLinks = settings.Social_links.split("|")
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
