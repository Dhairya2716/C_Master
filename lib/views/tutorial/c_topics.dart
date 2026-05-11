import '../../core/utils/import_export.dart';

final List<TopicModel> cTopics = [

  TopicModel(
    title: "Introduction",
    subtopics: [
      SubTopic(
        title: "What is C?",
        content: """
<p>C is a powerful general-purpose programming language. It can be used to develop software like operating systems, databases, compilers, and so on.</p>
<p>Example:</p>
<pre>
#include &lt;stdio.h&gt;
int main() {
  printf("Hello World");
  return 0;
}
</pre>
""",
      ),

      SubTopic(
        title: "History of C",
        content: "<p>C was developed by <b>Dennis Ritchie</b> in 1972 at Bell Labs.</p>",
      ),
    ],
  ),

  TopicModel(
    title: "Variables and Data Types",
    subtopics: [
      SubTopic(
        title: "What is a Variable?",
        content: "<p>A <b>variable</b> is a container (storage area) to hold data.</p><p>To indicate the storage area, each variable should be given a unique name (identifier).</p>",
      ),
      SubTopic(
        title: "Data Types",
        content: "<p>Data types are declarations for variables. This determines the type and size of data associated with variables.</p><ul><li><b>int</b>: integers</li><li><b>float</b>: floating-point numbers</li><li><b>char</b>: single characters</li><li><b>double</b>: double-precision floating-point numbers</li></ul>",
      ),
    ],
  ),

];
