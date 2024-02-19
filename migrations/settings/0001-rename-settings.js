export default function migrate(settings) {
  if (settings.has("Heading")) {
    settings.set("heading", settings.get("Heading"));
    settings.delete("Heading");
  }

  if (settings.has("Blurb")) {
    settings.set("blurb", settings.get("Blurb"));
    settings.delete("Blurb");
  }

  if (settings.has("Link_sections")) {
    settings.set("link_sections", settings.get("Link_sections"));
    settings.delete("Link_sections");
  }

  if (settings.has("Links")) {
    settings.set("links", settings.get("Links"));
    settings.delete("Links");
  }

  if (settings.has("Small_links")) {
    settings.set("small_links", settings.get("Small_links"));
    settings.delete("Small_links");
  }

  if (settings.has("Social_links")) {
    settings.set("social_links", settings.get("Social_links"));
    settings.delete("Social_links");
  }

  if (settings.has("Show_footer_on_login_required_page")) {
    settings.set(
      "show_footer_on_login_required_page",
      settings.get("Show_footer_on_login_required_page")
    );
    settings.delete("Show_footer_on_login_required_page");
  }

  return settings;
}
