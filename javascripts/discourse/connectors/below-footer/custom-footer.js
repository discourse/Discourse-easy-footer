import { dasherize } from "@ember/string";

export default {
  setupComponent(args, component) {
    try {
      const splitLinkSections = settings.Link_sections.split("|") || "";
      const splitLinks = settings.Links.split("|") || "";
      const splitSmallLinks = settings.Small_links.split("|") || "";
      const splitSocialLinks = settings.Social_links.split("|") || "";

      const linkArray = [];
      const sectionsArray = [];
      const smallLinksArray = [];
      const socialLinksArray = [];

      splitLinks.forEach(link => {
        const fragments = link.split(",").map(fragment => fragment.trim());
        const parent = fragments[0].toLowerCase();
        const text = fragments[1];
        const className = dasherize(text).toLowerCase();
        const href = fragments[2];
        const target = fragments[3] === "blank" ? "_blank" : "";
        const title = fragments[4];

        const linkItem = {
          parent: parent,
          text: text,
          className: className,
          href: href,
          target: target,
          title: title
        };
        linkArray.push(linkItem);
      });

      splitLinkSections.forEach(section => {
        const fragments = section.split(",").map(fragment => fragment.trim());
        const parentFor = fragments[0].toLowerCase();
        const text = fragments[0];
        const className = dasherize(text).toLowerCase();
        const title = fragments[1];
        const childLinks = linkArray.filter(link => link.parent === parentFor);

        const listItem = {
          parentFor: parentFor,
          text: text,
          className: className,
          childLinks
        };
        sectionsArray.push(listItem);
      });

      splitSocialLinks.forEach(link => {
        const fragments = link.split(",").map(fragment => fragment.trim());
        const text = fragments[0];
        const className = dasherize(text).toLowerCase();
        const title = fragments[1];
        const href = fragments[2];
        const target = fragments[3] === "blank" ? "_blank" : "";
        const icon = fragments[4].toLowerCase();

        const SocialLinkItem = {
          text: text,
          className: className,
          title: title,
          href: href,
          target: target,
          icon: icon
        };
        socialLinksArray.push(SocialLinkItem);
      });

      splitSmallLinks.forEach(link => {
        const fragments = link.split(",").map(fragment => fragment.trim());
        const text = fragments[0];
        const className = dasherize(text).toLowerCase();
        const href = fragments[1];
        const target = fragments[2] === "blank" ? "_blank" : "";

        const smallLinkItem = {
          text: text,
          className: className,
          href: href,
          target: target
        };
        smallLinksArray.push(smallLinkItem);
      });

      component.set("mainHeading", settings.Heading);
      component.set("blurb", settings.Blurb);
      component.set("linkSections", sectionsArray);
      component.set("smallLinks", smallLinksArray);
      component.set("socialLinks", socialLinksArray);
    } catch (error) {
      console.error(error);
      console.error(
        "There's an issue in the Easy Footer Component. Check if your settings are entered correctly"
      );
    }
  }
};
