Metamagic::Renderer.register_tag_type :canonical, ->(key, value) { tag :link, href: value, rel: 'canonical' }
Metamagic::Renderer.register_tag_type :charset, ->(key, value) { tag :meta, charset: value }
Metamagic::Renderer.register_tag_type :robots, ->(key, value) { tag :meta, content: value, name: 'robots' }
