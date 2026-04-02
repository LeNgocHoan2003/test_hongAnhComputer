/// Vietnamese-style currency grouping: 25.000.000đ
String formatVnd(int amount) {
  final s = amount.toString();
  final buf = StringBuffer();
  var pos = 0;
  final len = s.length;
  final rem = len % 3;
  if (rem > 0) {
    buf.write(s.substring(0, rem));
    pos = rem;
    if (pos < len) buf.write('.');
  }
  while (pos < len) {
    buf.write(s.substring(pos, pos + 3));
    pos += 3;
    if (pos < len) buf.write('.');
  }
  return '${buf.toString()}đ';
}
