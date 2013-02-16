module Jekyll
    class PostUrl < Liquid::Tag
        def render(context)
            site = context.registers[:site]

            site.posts.each do |p|
                cd = p.date.strftime('%Y-%m-%d') <=> @post.date.strftime('%Y-%m-%d')
                cs = p.slug <=> @post.slug
                if cd == 0 and cs == 0
                    return p.url
                end
            end
      
            puts "ERROR: post_url: \"#{@orig_post}\" could not be found"

            return "#"
        end
    end
end
