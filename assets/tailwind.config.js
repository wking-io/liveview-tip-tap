const { red, coolGray } = require('tailwindcss/colors');
const defaultTheme = require('tailwindcss/defaultTheme');

const greenGray = {
  50: '#F9FAF9',
  100: '#F4F5F4',
  200: '#E5E7E4',
  300: '#D2D6D1',
  400: '#A0A89E',
  500: '#6E786C',
  600: '#50574E',
  700: '#3D443C',
  800: '#252924',
  900: '#181C17',
};

const colors = {
  white: '#ffffff',
  transparent: 'transparent',
  brand: {
    100: '#CFD8E1',
    200: '#B1C1CC',
    300: '#92A6B1',
    400: '#617A7F',
    500: '#3C4B4E',
    600: '#2A3336',
  },
  gray: greenGray,
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
        books: 'repeat(auto-fit, minmax(120px, 1fr))',
      },
    },
  },
  variants: {
    extend: {},
  },
  plugins: [ require('@tailwindcss/typography'), require('@tailwindcss/forms'), require('@tailwindcss/aspect-ratio') ],
};
