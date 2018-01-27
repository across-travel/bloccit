require "omnicontacts"

Rails.application.middleware.use OmniContacts::Builder do
  importer :gmail, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'], {redirect_path: "/invites/gmail/contact_callback"}
  importer :yahoo, ENV['YAHOO_CLIENT_ID'], ENV['YAHOO_SECRET_ID'], {callback_path: "/invites/yahoo/contact_callback"}
  importer :outlook, ENV['OUTLOOK_CLIENT_ID'], ENV['OUTLOOK_SECRET_ID'], {redirect_path: "/invites/outlook/contact_callback"}
end
