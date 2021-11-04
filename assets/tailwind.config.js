const { red, blueGray } = require('tailwindcss/colors');
const defaultTheme = require('tailwindcss/defaultTheme');

const colors = {
  white: '#ffffff',
  transparent: 'transparent',
  brand: {
    100: '#FFBA8F',
    200: '#FF8B42',
    300: '#F2673D',
    400: '#00707A',
    500: '#E53A33',
  },
  gray: {
    100: '#D8E0D7',
    200: '#C5CFC4',
    300: '#ADBAAE',
    400: '#8A978B',
    500: '#8A978B',
    600: '#5B665C',
    700: '#5B665C',
    800: '#394039',
    900: '#394039',
  },
  error: red,
};

module.exports = {
  mode: 'jit',
  purge: [ '../lib/without_ceasing_web/**/*.{ex,leex,eex,heex}', './js/**/*.js' ],
  darkMode: false, // or 'media' or 'class'
  theme: {
    colors,
    fontFamily: {
      sans: [ 'Inter var', ...defaultTheme.fontFamily.sans ],
      serif: [ 'Bitter', ...defaultTheme.fontFamily.serif ],
    },
    extend: {
      boxShadow: {
        'box-gray': `4px 4px 0 ${colors.gray[300]}`,
        'box-300-sm': `4px 4px 0 ${colors.brand[300]}`,
        'box-300': `10px 10px 0 ${colors.brand[300]}`,
        'box-300-lg': `14px 14px 0 ${colors.brand[300]}`,
        'box-500': `10px 10px 0 ${colors.brand[500]}`,
        'box-500-lg': `14px 14px 0 ${colors.brand[500]}`,
        'box-error-sm': `4px 4px 0 ${colors.error[700]}`,
      },
      gridTemplateColumns: {
        books: 'repeat(auto-fit, minmax(150px, 1fr))',
      },
    },
  },
  variants: {
    extend: {},
  },
  plugins: [ require('@tailwindcss/typography'), require('@tailwindcss/forms'), require('@tailwindcss/aspect-ratio') ],
};
