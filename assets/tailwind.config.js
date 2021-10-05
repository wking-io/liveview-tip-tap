const { red, blueGray } = require('tailwindcss/colors');
const defaultTheme = require('tailwindcss/defaultTheme');

const colors = {
  white: '#ffffff',
  transparent: 'transparent',
  brand: {
    100: '#CAE6BF',
    200: '#50C5B6',
    300: '#00A1AF',
    400: '#00707A',
    500: '#064E55',
  },
  gray: blueGray,
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
    },
  },
  variants: {
    extend: {},
  },
  plugins: [ require('@tailwindcss/typography'), require('@tailwindcss/forms'), require('@tailwindcss/aspect-ratio') ],
};
