require 'fileutils'

subdirs = {}
subdirs["tmcl"] = %w[abstract-constraint allowed allowed-reifier allows association-role-constraint association-type belongs-to belongs-to-schema card-max card-min comment constrained constrained-construct constrained-role constrained-scope constrained-scope-topic constrained-statement constrained-topic-type constraint containee container datatype denial-constraint description includes-schema item-identifier-constraint name-type occurrence-datatype-constraint occurrence-type other-constrained-role other-constrained-topic-type overlap-declaration overlaps regexp regular-expression-constraint reifier-constraint requirement-constraint role-combination-constraint role-type schema schema-resource scope-constraint scope-required-constraint see-also subject-identifier-constraint subject-locator-constraint topic-map topic-name-constraint topic-occurrence-constraint topic-reifies-constraint topic-role-constraint topic-type unique-value-constraint used user user-defined-constraint uses-schema validation-expression variant-name-constraint version]
subdirs["iso13250"] = %w[ctm-integer]
subdirs["iso13250/model"] = %w[instance sort subject subtype supertype supertype-subtype topic-name type type-instance name-type]
subdirs["iso13250/glossary"] = %w[association association-role association-role-type association-type information-resource item-identifier locator merging occurrence occurrence-type reification scope statement subject subject-identifier subject-indicator subject-locator topic topic-map topic-map-construct Topic-Maps topic-name topic-name-type topic-type unconstrained-scope variant-name]

content = Hash.new{|h,k| h[k] = {}}
content["tmcl"] = {:name => "Topic Maps Constraint Language (TMCL) [ISO 19756]", :url => "http://isotopicmaps.org/tmcl/tmcl.html", :published=>"2010-03-25"}
content["iso13250"] = {:name => "ISO 13250 Topic Maps", :url => "http://isotopicmaps.org/", :published=>"2010-03-31"}
content["iso13250/model"] = {:name => "Topic Maps Data Model (TMDM) [ISO 13250-2]", :url => "http://isotopicmaps.org/tmdm/", :published=>"2008-06-03"}
content["iso13250/glossary"] = {:name => "Topic Maps Data Model (TMDM) [ISO 13250-2] - Glossary", :url => "http://isotopicmaps.org/tmdm/", :published=>"2008-06-03",
    :note=>"This subject identifier is defined in the annex of TMDM to uniquely identify the formally defined term in Clause 3. The subject identifiers are defined for the sole purpose of enabling unambiguous reference to the subjects they identify, for example in order to enable the collation of information about those subjects. This part of ISO/IEC13250 attaches no processing semantics of any kind to these identifiers, over and above those associated with subject identifiers in general. -- or in short: You should not use this identifier except you want to speak about the <em>usage of the term in the TMDM</em>."}
content["iso13250/ctm"] = {:name => "Compact Topic Maps Syntax (CTM) [ISO 13250-6]", :url => "http://isotopicmaps.org/ctm/ctm.html", :published=>"2010-03-31"}
content["iso13250/xtm"] = {:name => "XML Topic Maps Syntax (XTM) [ISO 13250-3: 2007]", :url => "http://isotopicmaps.org/xtm/", :published=>"2006-06-19"}

content["iso13250/model/name-type"] = {:status => "DO NOT USE", :note => "This identifier was created due to an editorial error and should not be used. The correct identifier is http://psi.topicmaps.org/iso13250/model/topic-name.", :published=>"2006-06-18"}

def header(title=nil)
<<-EOS
<!DOCTYPE html>
<html><head>
<title>#{title || "Published Subject Identifiers for Topic Maps"}</title>
</head><body>
EOS
end
def footer
<<-EOS
  <script type="text/javascript">

  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-10825716-3']);
  _gaq.push(['_trackPageview']);

  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();

</script>
</body>
</html>
EOS
end
# TODO:
# favicon

# hack for sub-access, instead of try()
class NilClass
  def [](*args)
    nil
  end
end

subdirs.each do |prefix, locals|
  FileUtils.mkdir_p prefix
  locals.each do |local|
    File.open("#{prefix}/#{local}.html", "w") do |f|
      f.puts <<-EOS
#{header("Published Subject Identifiers for #{content[prefix][:name]}: #{local}")}
<h1>#{local}</h1><p>Subject Indicator for <em>#{local}</em> in #{content[prefix][:name]}. See <a href="#{content[prefix][:url]}">#{content[prefix][:url]}</a> for more information about <em>#{local}</em>.</p>
<p>
Status: #{content[prefix+"/"+local][:status] || "stable"}<br/>
Publisher: ISO/IEC JTC1/SC34<br/>
Published: #{content[prefix+"/"+local][:published] || content[prefix][:published]}
</p>
#{"<p>#{content[prefix][:note]}</p>" if content[prefix][:note]}
#{"<p>#{content[prefix+"/"+local][:note]}</p>" if content[prefix+"/"+local][:note]}
#{footer}
EOS
    end
  end
  File.open("#{prefix}/index.html","w") do |f|
    f.puts <<-EOS
#{header("Published Subject Identifiers for #{content[prefix][:name]}")}
<h1>Subject Indicators for #{content[prefix][:name]}</h1>
<p>See  <a href="#{content[prefix][:url]}">#{content[prefix][:url]}</a> for more information.</p>
<ul>
#{locals.map{|e| "<li><a href=\"#{e}\">#{e}</a></li>"}.join("\n")}
</ul>
#{footer}
EOS
  end
end

File.open("index.html", "w") do |f|
  f.puts <<-EOS
#{header}
<h1>Published Subject Identifiers for Topic Maps-related standards</h1>
<p>These pages are subject indicators for the published subject identifiers defined in various Topic Maps-related standards. Please refer to <a href="http://www.topicmaps.org">www.topicmaps.org</a> for more information about Topic Maps. Standard-specific information can be found at <a href="http://www.isotopicmaps.org">www.isotopicmaps.org</a>.</p>
<ul>
#{subdirs.keys.sort.map{|e| "<li><a href=\"#{e}\">#{content[e][:name] || e}</a></li>"}.join("\n")}
</ul>
#{footer}
EOS
end
