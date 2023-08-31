import Component from "@glimmer/component";

// Used instead of dasherize for backwards compatibility with stable
const getClassName = (text) => {
  return text.toLowerCase().replace(/\s/g, "-");
};

export default class extends Component {
  mainHeading = settings.Heading;
  blurb = settings.Blurb;

  linkArray = settings.Links.split("|")
    .filter(Boolean)
    .map((link) => {
      const fragments = link.split(",").map((fragment) => fragment.trim());
      const parent = fragments[0].toLowerCase();
      const text = fragments[1];
      const className = getClassName(text);
      const href = fragments[2];
      const target = fragments[3] === "blank" ? "_blank" : "";
      const title = fragments[4];

      return {
        parent,
        text,
        className,
        href,
        target,
        title,
      };
    });

  linkSections = settings.Link_sections.split("|")
    .filter(Boolean)
    .map((section) => {
      const fragments = section.split(",").map((fragment) => fragment.trim());
      const parentFor = fragments[0].toLowerCase();
      const text = fragments[0];
      const className = getClassName(text);
      const childLinks = this.linkArray.filter(
        (link) => link.parent === parentFor
      );

      return {
        text,
        className,
        childLinks,
      };
    });

  smallLinks = settings.Small_links.split("|")
    .filter(Boolean)
    .map((link) => {
      const fragments = link.split(",").map((fragment) => fragment.trim());
      const text = fragments[0];
      const className = getClassName(text);
      const href = fragments[1];
      const target = fragments[2] === "blank" ? "_blank" : "";

      return {
        text,
        className,
        href,
        target,
      };
    });

  socialLinks = settings.Social_links.split("|")
    .filter(Boolean)
    .map((link) => {
      const fragments = link.split(",").map((fragment) => fragment.trim());
      const text = fragments[0];
      const className = getClassName(text);
      const title = fragments[1];
      const href = fragments[2];
      const target = fragments[3] === "blank" ? "_blank" : "";
      const icon = fragments[4].toLowerCase();

      return {
        text,
        className,
        title,
        href,
        target,
        icon,
      };
    });
}
