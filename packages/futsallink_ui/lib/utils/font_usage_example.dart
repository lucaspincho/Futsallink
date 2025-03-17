import 'package:flutter/material.dart';
import '../tokens/typography.dart';

/// Este arquivo é apenas um exemplo de como usar a fonte Unbounded em todo o projeto.
/// Você pode usar a classe UnboundedFont diretamente ou os estilos pré-definidos em FutsallinkTypography.

class FontUsageExample extends StatelessWidget {
  const FontUsageExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exemplo de Uso da Fonte', style: UnboundedFont.bold(size: 18)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Usando estilos pré-definidos
            Text('Headline 1', style: FutsallinkTypography.headline1),
            const SizedBox(height: 8),
            
            Text('Headline 2', style: FutsallinkTypography.headline2),
            const SizedBox(height: 8),
            
            Text('Headline 3', style: FutsallinkTypography.headline3),
            const SizedBox(height: 8),
            
            Text('Subtítulo 1', style: FutsallinkTypography.subtitle1),
            const SizedBox(height: 8),
            
            Text('Subtítulo 2', style: FutsallinkTypography.subtitle2),
            const SizedBox(height: 8),
            
            Text('Texto do corpo 1', style: FutsallinkTypography.body1),
            const SizedBox(height: 8),
            
            Text('Texto do corpo 2', style: FutsallinkTypography.body2),
            const SizedBox(height: 16),
            
            // Usando a classe UnboundedFont diretamente
            Text(
              'Texto Light (300)',
              style: UnboundedFont.light(size: 16),
            ),
            const SizedBox(height: 8),
            
            Text(
              'Texto Regular (400)',
              style: UnboundedFont.regular(size: 16),
            ),
            const SizedBox(height: 8),
            
            Text(
              'Texto Medium (500)',
              style: UnboundedFont.medium(size: 16),
            ),
            const SizedBox(height: 8),
            
            Text(
              'Texto SemiBold (600)',
              style: UnboundedFont.semiBold(size: 16),
            ),
            const SizedBox(height: 8),
            
            Text(
              'Texto Bold (700)',
              style: UnboundedFont.bold(size: 16),
            ),
            const SizedBox(height: 8),
            
            Text(
              'Texto ExtraBold (800)',
              style: UnboundedFont.extraBold(size: 16),
            ),
            const SizedBox(height: 16),
            
            // Customizando a fonte
            Text(
              'Fonte com cor personalizada',
              style: UnboundedFont.medium(
                size: 18,
                color: Colors.blue,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            
            Text(
              'Fonte com decoração e altura de linha',
              style: UnboundedFont.regular(
                size: 16,
                height: 1.5,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 