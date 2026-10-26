# ÚLTIMO ESTOQUE — animação

Projeto de animação 2D em HTML/SVG/CSS/GSAP, pensado para render local em vídeo vertical 1080×1920.

## Renderizar tudo (Windows)

Pré-requisitos:
- Node.js 22 ou superior
- FFmpeg instalado e disponível no PATH
- Internet na primeira execução para o npx baixar o HyperFrames

Abra o PowerShell nesta pasta e execute:

    Set-ExecutionPolicy -Scope Process Bypass
    .\render-all.ps1

O script renderiza as seis cenas individualmente e gera:

    renders/ULTIMO-ESTOQUE.mp4

## Renderizar uma cena isolada

    npx --yes hyperframes render --composition scene1-apartment.html --output renders/scene1.mp4 --fps 30 --quality standard

## Ordem narrativa

1. Apartamento — alerta inicial
2. Corredor — batidas na porta
3. Cozinha — procura por suprimentos
4. Entrada — preparação para sair
5. Rua e mercado — encontro com zumbi e mensagem no celular
6. Final — contagem regressiva e gancho

Observação: as cenas usam timelines GSAP próprias. O script renderiza cada cena separadamente e concatena os MP4s no final. Confira o primeiro render; se sua versão do HyperFrames exigir um projeto raiz, siga a mensagem de diagnóstico do CLI.