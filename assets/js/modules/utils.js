export const pipe = (...fns) => (x) => fns.reduce((v, f) => f(v), x);
export const attrToBool = (el, attr) => el.getAttribute(attr) === 'true';
