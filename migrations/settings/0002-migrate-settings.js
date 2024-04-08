export default function migrate(settings) {
  const oldLinkSections = settings.get("link_sections");

  if (oldLinkSections) {
    const newLinkSections = oldLinkSections.split("|").map((linkSection) => {
      const [linkSectionName, linkSectionTitle] = linkSection
        .split(",")
        .map((value) => value.trim());

      return {
        text: linkSectionName,
        title: linkSectionTitle,
      };
    });

    const oldLinkSectionLinks = settings.get("links");

    if (oldLinkSectionLinks) {
      oldLinkSectionLinks.split("|").map((linkSectionLink) => {
        const [
          linkSectionName,
          linkName,
          linkUrl,
          linkTarget,
          linkTitle,
          linkReferrerPolicy,
        ] = linkSectionLink.split(",").map((value) => value.trim());

        const linkSection = newLinkSections.find(
          (section) => section.text === linkSectionName
        );

        if (linkSection) {
          if (!linkSection.links) {
            linkSection.links = [];
          }

          let target;

          switch (linkTarget) {
            case "blank":
              target = "_blank";
              break;
            case "self":
              target = "_self";
              break;
            default:
              break;
          }

          const link = {
            text: linkName,
            url: linkUrl,
            title: linkTitle || linkTarget, // There is a bug in the previous default which may have set the title to the target field
          };

          if (target) {
            link.target = target;
          }

          if (
            [
              "no-referrer",
              "no-referrer-when-downgrade",
              "origin",
              "origin-when-cross-origin",
              "unsafe-url",
            ].includes(linkReferrerPolicy)
          ) {
            link.referrer_policy = linkReferrerPolicy;
          }

          linkSection.links.push(link);
        }
      });
    }

    settings.set("sections", newLinkSections);
    settings.delete("link_sections");
    settings.delete("links");
  }

  return settings;
}
