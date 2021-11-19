const { orange, trueGray, amber, teal } = require('tailwindcss/colors');
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
  gray: trueGray,
  success: teal,
  warning: amber,
  error: orange,
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
      animation: {
        'enter-bottom': 'enter-bottom 300ms ease-out both',
        'enter-left': 'enter-left 300ms ease-out both',
        'enter-left-full': 'enter-left-full 200ms ease-out both',
        'enter-right': 'enter-right 300ms ease-out both',
        'enter-top': 'enter-top 300ms ease-out both',
        'exit-top': 'enter-top 100ms ease-in both',
      },
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
      keyframes: {
        'enter-bottom': {
          '0%': {
            opacity: 0,
            transform: 'translateY(16px)',
          },
          '100%': {
            opacity: 1,
            transform: 'translateY(0)',
          },
        },
        'enter-left': {
          '0%': {
            opacity: 0,
            transform: 'translateX(-16px)',
          },
          '100%': {
            opacity: 1,
            transform: 'translateX(0)',
          },
        },
        'enter-left-full': {
          '0%': {
            transform: 'translateX(-100%)',
          },
          '100%': {
            transform: 'translateX(0)',
          },
        },
        'enter-right': {
          '0%': {
            opacity: 0,
            transform: 'translateX(16px)',
          },
          '100%': {
            opacity: 1,
            transform: 'translateX(0)',
          },
        },
        'enter-top': {
          '0%': {
            opacity: 0,
            transform: 'translateY(-16px)',
          },
          '100%': {
            opacity: 1,
            transform: 'translateY(0)',
          },
        },
        'exit-bottom': {
          '0%': {
            opacity: 1,
            transform: 'translateY(0)',
          },
          '100%': {
            opacity: 0,
            transform: 'translateY(16px)',
          },
        },
      },
    },
  },
  variants: {
    extend: {},
  },
  plugins: [ require('@tailwindcss/typography'), require('@tailwindcss/forms'), require('@tailwindcss/aspect-ratio') ],
};
