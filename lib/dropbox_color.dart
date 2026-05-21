import 'dart:ui';

final class DropboxColor {
  const DropboxColor({
    required this.label,
    required this.labelColor,
    required this.colorCode,
    required this.color,
  });

  final String label;

  final Color labelColor;

  final Color color;

  final String colorCode;
}

abstract final class DropboxColors {
  static const _darkLabelColor = Color(0xFF1E1919);

  static const _lightLabelColor = Color(0xFFF7F6F5);

  static const blue = DropboxColor(
    label: 'Dropbox Blue',
    labelColor: _lightLabelColor,
    color: Color(0xFF0061FE),
    colorCode: '#0061FE',
  );

  static const coconut = DropboxColor(
    label: 'Coconut',
    labelColor: _darkLabelColor,
    color: Color(0xFFF7F5F2),
    colorCode: '#F7F5F2',
  );

  static const graphite = DropboxColor(
    label: 'Graphite',
    labelColor: _lightLabelColor,
    color: Color(0xFF1E1919),
    colorCode: '#1E1919',
  );

  static const azalea = DropboxColor(
    label: 'Azalea',
    labelColor: _lightLabelColor,
    color: Color(0xFFCD2F7B),
    colorCode: '#CD2F7B',
  );

  static const pink = DropboxColor(
    label: 'Pink',
    labelColor: _darkLabelColor,
    color: Color(0xFFFFAFA5),
    colorCode: '#FFAFA5',
  );

  static const crimson = DropboxColor(
    label: 'Crimson',
    labelColor: _lightLabelColor,
    color: Color(0xFF9B0032),
    colorCode: '#9B0032',
  );

  static const sunset = DropboxColor(
    label: 'Sunset',
    labelColor: _darkLabelColor,
    color: Color(0xFFFA551E),
    colorCode: '#FA551E',
  );

  static const rust = DropboxColor(
    label: 'Rust',
    labelColor: _lightLabelColor,
    color: Color(0xFFBE4B0A),
    colorCode: '#BE4B0A',
  );

  static const tangerine = DropboxColor(
    label: 'Tangerine',
    labelColor: _darkLabelColor,
    color: Color(0xFFFF8C19),
    colorCode: '#FF8C19',
  );

  static const gold = DropboxColor(
    label: 'Gold',
    labelColor: _lightLabelColor,
    color: Color(0xFF9B6400),
    colorCode: '#9B6400',
  );

  static const vividVargas = DropboxColor(
    label: 'Vivid Vargas',
    labelColor: _darkLabelColor,
    color: Color(0xFFFAD24B),
    colorCode: '#FAD24B',
  );

  static const canopy = DropboxColor(
    label: 'Canopy',
    labelColor: _lightLabelColor,
    color: Color(0xFF0F503C),
    colorCode: '#0F503C',
  );

  static const lime = DropboxColor(
    label: 'Lime',
    labelColor: _darkLabelColor,
    color: Color(0xFFB4DC19),
    colorCode: '#B4DC19',
  );

  static const ocean = DropboxColor(
    label: 'Ocean',
    labelColor: _lightLabelColor,
    color: Color(0xFF007891),
    colorCode: '#007891',
  );

  static const zen = DropboxColor(
    label: 'Zen',
    labelColor: _darkLabelColor,
    color: Color(0xFF14C8EB),
    colorCode: '#14C8EB',
  );

  static const navy = DropboxColor(
    label: 'Navy',
    labelColor: _lightLabelColor,
    color: Color(0xFF283750),
    colorCode: '#283750',
  );

  static const cloud = DropboxColor(
    label: 'Cloud',
    labelColor: _darkLabelColor,
    color: Color(0xFFB4C8E1),
    colorCode: '#B4C8E1',
  );

  static const plum = DropboxColor(
    label: 'Plum',
    labelColor: _lightLabelColor,
    color: Color(0xFF78286E),
    colorCode: '#78286E',
  );

  static const orchid = DropboxColor(
    label: 'Orchid',
    labelColor: _darkLabelColor,
    color: Color(0xFFC8AFF0),
    colorCode: '#C8AFF0',
  );

  static const grey1000 = DropboxColor(
    label: '1000',
    labelColor: _lightLabelColor,
    color: Color(0xFF1A1918),
    colorCode: '#1A1918',
  );

  static const grey950 = DropboxColor(
    label: '950',
    labelColor: _lightLabelColor,
    color: Color(0xFF242321),
    colorCode: '#242321',
  );

  static const grey900 = DropboxColor(
    label: '900',
    labelColor: _lightLabelColor,
    color: Color(0xFF2D2B29),
    colorCode: '#2D2B29',
  );

  static const grey850 = DropboxColor(
    label: '850',
    labelColor: _lightLabelColor,
    color: Color(0xFF393633),
    colorCode: '#393633',
  );

  static const grey800 = DropboxColor(
    label: '800',
    labelColor: _lightLabelColor,
    color: Color(0xFF44403D),
    colorCode: '#44403D',
  );

  static const grey750 = DropboxColor(
    label: '750',
    labelColor: _lightLabelColor,
    color: Color(0xFF4F4A46),
    colorCode: '#4F4A46',
  );

  static const grey700 = DropboxColor(
    label: '700',
    labelColor: _lightLabelColor,
    color: Color(0xFF5B5650),
    colorCode: '#5B5650',
  );

  static const grey650 = DropboxColor(
    label: '650',
    labelColor: _lightLabelColor,
    color: Color(0xFF67615A),
    colorCode: '#67615A',
  );

  static const grey600 = DropboxColor(
    label: '600',
    labelColor: _lightLabelColor,
    color: Color(0xFF736C64),
    colorCode: '#736C64',
  );

  static const grey550 = DropboxColor(
    label: '550',
    labelColor: _lightLabelColor,
    color: Color(0xFF7F776F),
    colorCode: '#7F776F',
  );

  static const grey500 = DropboxColor(
    label: '500',
    labelColor: _lightLabelColor,
    color: Color(0xFF8C8279),
    colorCode: '#8C8279',
  );

  static const grey450 = DropboxColor(
    label: '450',
    labelColor: _lightLabelColor,
    color: Color(0xFF978F86),
    colorCode: '#978F86',
  );

  static const grey400 = DropboxColor(
    label: '400',
    labelColor: _lightLabelColor,
    color: Color(0xFFA49B93),
    colorCode: '#A49B93',
  );

  static const grey350 = DropboxColor(
    label: '350',
    labelColor: _darkLabelColor,
    color: Color(0xFFAFA8A0),
    colorCode: '#AFA8A0',
  );

  static const grey300 = DropboxColor(
    label: '300',
    labelColor: _darkLabelColor,
    color: Color(0xFFBBB5AE),
    colorCode: '#BBB5AE',
  );

  static const grey250 = DropboxColor(
    label: '250',
    labelColor: _darkLabelColor,
    color: Color(0xFFC7C1BB),
    colorCode: '#C7C1BB',
  );

  static const grey200 = DropboxColor(
    label: '200',
    labelColor: _darkLabelColor,
    color: Color(0xFFD3CEC9),
    colorCode: '#D3CEC9',
  );

  static const grey150 = DropboxColor(
    label: '150',
    labelColor: _darkLabelColor,
    color: Color(0xFFDFDCD8),
    colorCode: '#DFDCD8',
  );

  static const grey100 = DropboxColor(
    label: '100',
    labelColor: _darkLabelColor,
    color: Color(0xFFEBE9E6),
    colorCode: '#EBE9E6',
  );

  static const grey50 = DropboxColor(
    label: '50',
    labelColor: _darkLabelColor,
    color: Color(0xFFF7F6F5),
    colorCode: '#F7F6F5',
  );
}
