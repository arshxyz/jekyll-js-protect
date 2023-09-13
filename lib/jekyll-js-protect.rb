require "jekyll"

module Jekyll
    module Filter
      def email_protect(input)
        render(input, 'email_protect')
      end

      def tel_protect(input)
        render(input, 'tel_protect')
      end

      def string_protect(input)
        render(input, 'string_protect')
      end

      private

      def render(text, tag_name)
        prefix = {"email_protect" => "_e", "tel_protect" => "_p", "string_protect" => "_n"}
        encoded_string = Base64.encode64(text)
        tag = if tag_name == "string_protect" then "span" else "a" end
        "<#{tag} class=\"protect\">#{prefix[tag_name]}#{encoded_string}</#{tag}>" + "<noscript>(Base 64 Decode \"#{encoded_string}\" to see)</noscript>"
      end
    end
    class Hook 
      class << self
        def add_to_head(page)
          require 'nokogiri'
          if page.output.include? "<head"
            doc = Nokogiri::HTML(page.output)
            head = doc.at("head")
            head.add_child("<script> document.addEventListener(\"DOMContentLoaded\",()=>{const e=document.querySelectorAll(\".protect\");e.forEach(e=>{base64=e.innerHTML;if(base64.length>=2){switch(base64.slice(0,2)){case\"_e\":e.innerHTML=a(base64);e.href=\"mailto:\"+unmask;break;case\"_p\":e.innerHTML=a(base64);e.href=\"tel:\"+unmask;break;case\"_n\":e.innerHTML=a(base64);default:break}}})});function a(e){e=e.slice(2);unmask=atob(e);return unmask}</script>")
            head.add_child("<noscript><style> .protect {display: none;}</style></noscript>")
            page.output = doc.to_html
          end
        end
      end
    end
end

Jekyll::Hooks.register [:pages, :documents], :post_render do |page|
  Jekyll::Hook.add_to_head(page)
end
Liquid::Template.register_filter(Jekyll::Filter)