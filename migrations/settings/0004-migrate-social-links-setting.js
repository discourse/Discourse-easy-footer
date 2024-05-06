export default function migrate(settings, helpers) {
  const oldSocialLinks = settings.get("social_links");

  if (oldSocialLinks) {
    const newSocialLinks = [];

    oldSocialLinks.split("|").forEach((oldSocialLink) => {
      const [linkText, linkTitle, linkUrl, linkTarget, linkIcon] = oldSocialLink
        .split(",")
        .map((value) => value.trim());

      if (linkText) {
        const newLink = {
          text: linkText,
        };

        if (linkTitle) {
          newLink.title = linkTitle.substring(0, 1000);
        }

        if (linkUrl && helpers.isValidUrl(linkUrl) && linkUrl.length <= 2048) {
          newLink.url = linkUrl;
        } else {
          newLink.url = "#";
        }

        if (linkTarget === "self") {
          newLink.target = "_self";
        } else {
          newLink.target = "_blank";
        }

        if (linkIcon && linkIcon.length <= 200) {
          newLink.icon_name = linkIcon.toLowerCase();
        }

        newSocialLinks.push(newLink);
      }
    });

    settings.set("social_links", newSocialLinks);
  } else if (oldSocialLinks?.trim() === "") {
    settings.set("social_links", []);
  }

  return settings;
}
