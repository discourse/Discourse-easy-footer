export default function migrate(settings, helpers) {
  const oldSmallLinks = settings.get("small_links");

  if (oldSmallLinks) {
    const newSmallLinks = [];

    oldSmallLinks.split("|").forEach((link) => {
      const [linkText, linkUrl, linkTarget] = link
        .split(",")
        .map((fragment) => fragment.trim());

      if (linkText) {
        const newSmallLink = {
          text: linkText.substring(0, 1000),
        };

        if (linkUrl && helpers.isValidUrl(linkUrl) && linkUrl.length <= 2048) {
          newSmallLink.url = linkUrl;
        } else {
          newSmallLink.url = "#";
        }

        if (linkTarget === "self") {
          newSmallLink.target = "_self";
        } else {
          newSmallLink.target = "_blank";
        }

        newSmallLinks.push(newSmallLink);
      }
    });

    settings.set("small_links", newSmallLinks);
  } else if (oldSmallLinks?.trim() === "") {
    settings.set("small_links", []);
  }

  return settings;
}
